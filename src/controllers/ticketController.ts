import { NextFunction, Request, Response } from "express";
import {
  getTickets,
  createTicket,
  updateTicketPaidstatus,
} from "../services/ticketService";
import { TicketError } from "../errors/ticketError";
export interface GetTicketsParam {
  email: string;
}

export interface AddTicketPayload {
  email: string;
  seat_name: string;
  seat_type: string;
  seat_price: number;
  flight_id: string;
  luggage_type_id: number;
  insurance_type_id: number;
}

export interface PayTicketPayload {
  email: string;
  amount: number;
  ticket_id: number;
}

export const getAllTickets = async (
  req: Request<{}, {}, {}, GetTicketsParam>,
  res: Response
) => {
  // Extract query parameters
  const { email } = req.query;
  if (!email) {
    return res.status(400).json({
      message: "email is required",
    });
  }

  try {
    const tickets = await getTickets(req.query);
    res.json(tickets);
  } catch (error) {
    res.status(500).json({ message: "Error fetching tickets" });
  }
};

export const addTicket = async (req: Request, res: Response) => {
  try {
    console.log("ticket", req.body);
    const ticketId = await createTicket(req.body);
    res
      .status(201)
      .json({ message: "Ticket created successfully", id: ticketId });
  } catch (error) {
    console.log(error);
    res
      .status((error as TicketError).statusCode)
      .json({ message: (error as TicketError).message });
  }
};

export const payTicket = async (
  req: Request<{}, {}, PayTicketPayload>,
  res: Response
) => {
  try {
    console.log("ticket", req.body);
    await updateTicketPaidstatus(req.body);
    res
      .status(201)
      .json({ message: "Paid successfully", amount: req.body.amount });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: (error as Error).message });
  }
};
