import pool from "../config/db";
import { Ticket } from "../models/Ticket";
import {
  AddTicketPayload,
  PayTicketPayload,
  GetTicketsParam,
} from "../controllers/ticketController";
import {
  InvalidLuggageError,
  InvalidInsuranceError,
  InvalidFlightError,
  SeatReservedError,
} from "../errors/ticketError";
import { QueryResult } from "mysql2";

export interface TicketTotalPrice {
  ticket_price: number;
  seat_price: number;
  insurance_price?: number;
  luggage_price?: number;
}

export const getTickets = async (param: GetTicketsParam): Promise<Ticket[]> => {
  try {
    let query =
      "SELECT  ticket.ticket_id, passenger.email, passenger.first_name, passenger.last_name, ticket.created_date, ticket.paid_status, ticket.paid_date, flight.departure_time,flight.arrival_time, flight.departure_airport_code, flight.arrival_airport_code, seat.name as seat_name, seat.price as seat_price, seat.type as seat_type, luggage_ticket.luggage_id as luggage_type_id, insurance_ticket.insurance_id as insurance_type_id FROM ticket JOIN flight ON ticket.flight_id = flight.flight_id JOIN passenger ON ticket.email = passenger.email JOIN seat ON flight.flight_id = seat.flight_id LEFT JOIN luggage_ticket on luggage_ticket.ticket_id = ticket.ticket_id LEFT JOIN insurance_ticket on insurance_ticket.ticket_id = ticket.ticket_id  WHERE ticket.email = ?";
    const queryParams: string[] = [param.email];

    const [rows] = await pool.query(query, queryParams);
    return rows as Ticket[];
  } catch (error) {
    throw error;
  }
};

export const createTicket = async (
  payload: AddTicketPayload
): Promise<void> => {
  // 1. Check if luggage_type_id and insurance_type_id exist
  if (payload.luggage_type_id) {
    const [luggage] = await pool.query(
      "SELECT * FROM Luggage WHERE luggage_id = ?",
      [payload.luggage_type_id]
    );

    if ((luggage as any[]).length === 0) {
      throw new InvalidLuggageError();
    }
  }
  if (payload.insurance_type_id) {
    const [insurance] = await pool.query(
      "SELECT * FROM Insurance WHERE insurance_id = ?",
      [payload.insurance_type_id]
    );

    if ((insurance as any[]).length === 0) {
      throw new InvalidInsuranceError();
    }
  }

  // 2. Check if flight_id exists
  const [flight] = await pool.query(
    "SELECT * FROM Flight WHERE flight_id = ?",
    [payload.flight_id]
  );

  if ((flight as any[]).length === 0) {
    throw new InvalidFlightError();
  }

  // 3. Check if the email exists in Passenger, if not create a new one
  const [passenger] = await pool.query(
    "SELECT * FROM Passenger WHERE email = ?",
    [payload.email]
  );

  if ((passenger as any[]).length === 0) {
    await pool.query(
      "INSERT INTO Passenger (email, phone, first_name, last_name) VALUES (?, NULL, NULL, NULL)",
      [payload.email]
    );
  }

  // 4. Check if seat_name exists for the flight
  const [seat] = await pool.query(
    "SELECT * FROM Seat WHERE flight_id = ? AND name = ?",
    [payload.flight_id, payload.seat_name]
  );

  if ((seat as any[]).length > 0) {
    throw new SeatReservedError();
  }

  // 5. Create the ticket
  const [result] = await pool.query(
    "INSERT INTO Ticket (created_date, paid_status, paid_date, email, flight_id) VALUES (NOW(), FALSE, NULL, ?, ?)",
    [payload.email, payload.flight_id]
  );

  const ticketId = (result as any).insertId;

  // 6. Link luggage and insurance to the ticket
  if (payload.luggage_type_id) {
    await pool.query(
      "INSERT INTO Luggage_Ticket (ticket_id, luggage_id) VALUES (?, ?)",
      [ticketId, payload.luggage_type_id]
    );
  }

  if (payload.insurance_type_id) {
    await pool.query(
      "INSERT INTO Insurance_Ticket (ticket_id, insurance_id) VALUES (?, ?)",
      [ticketId, payload.insurance_type_id]
    );
  }

  // Reserve seat for the ticket
  await pool.query(
    "INSERT INTO Seat (name, type, price, flight_id, ticket_id) VALUES (?, ?, ?, ?, ?)",
    [
      payload.seat_name,
      payload.seat_type,
      payload.seat_price,
      payload.flight_id,
      Number(ticketId),
    ]
  );

  // return ticketId
  return ticketId;
};

export const updateTicketPaidstatus = async (
  payload: PayTicketPayload
): Promise<void> => {
  // Check if ticket_id and email match
  const [ticket]: any = await pool.query(
    `SELECT ticket.ticket_id, ticket.paid_status, ticket.paid_date, flight.price as flight_price, luggage.price as luggage_price, insurance.price as insurance_price,
seat.price as seat_price
    FROM ticket 
    LEFT JOIN flight ON ticket.flight_id = flight.flight_id 
    LEFT JOIN luggage_ticket ON luggage_ticket.ticket_id = ticket.ticket_id 
    LEFT JOIN luggage ON luggage_ticket.luggage_id = luggage.luggage_id 
    LEFT JOIN insurance_ticket ON insurance_ticket.ticket_id = ticket.ticket_id 
    LEFT JOIN insurance ON insurance.insurance_id = insurance_ticket.insurance_id
    LEFT JOIN seat on ticket.ticket_id = seat.ticket_id WHERE ticket.ticket_id = ? AND ticket.email = ?`,
    [payload.ticket_id, payload.email]
  );
  if (!ticket || ticket.length === 0) {
    throw new Error("Ticket not found or email does not match.");
  }

  const ticketInfo = ticket[0];

  // if ticket was paid
  if (ticketInfo.paid_status === 1) {
    throw new Error(`Ticket was paid on ${ticketInfo.paid_date}`);
  }

  // Calculate total amount to be paid (Flight price + Seat price + Luggage and Insurance if applicable)
  const { flight_price, seat_price, luggage_price, insurance_price } =
    ticketInfo;

  console.log("ticketInfo", ticketInfo);
  // Calculate expected amount
  const expected_amount =
    Number(flight_price) +
    Number(seat_price) +
    Number(luggage_price) +
    Number(insurance_price);

  // Validate amount
  if (payload.amount !== expected_amount) {
    throw new Error(`Incorrect amount. Expected to pay ${expected_amount}`);
  }
  // Update the paid_status
  await pool.query(
    "UPDATE Ticket SET paid_status = 1, paid_date = NOW() WHERE ticket_id = ?",
    [payload.ticket_id]
  );
};
