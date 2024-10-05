import pool from "../config/db";
import { Flight } from "../models/Flight";
import { GetFlightsParam, } from "../controllers/flightController";

export const getFlights = async (param: GetFlightsParam): Promise<Flight[]> => {
  try {
    let query = `SELECT * FROM Flight JOIN Aircraft ON Flight.aircraft_id = Aircraft.aircraft_id WHERE departure_time >= ? AND departure_airport_code = ? AND arrival_airport_code = ?`;
    const queryParams: string[] = [param.departure_time, param.departure_airport_code, param.arrival_airport_code];

    // Add optional parameters to the query
    if (param.arrival_time) {
      query += ` AND arrival_time <= ?`;
      queryParams.push(param.arrival_time);
    }    

    if (param.is_round_trip) {
      // For round trips, we can check if the return flight exists, this logic could change based on how round trips are defined in the system.
      // query += ` AND EXISTS (
      //       SELECT 1 FROM Flight AS return_flight
      //       WHERE return_flight.departure_airport_code = Flight.arrival_airport_code
      //       AND return_flight.arrival_airport_code = Flight.departure_airport_code
      //       AND return_flight.departure_time > Flight.arrival_time
      //   )`;
    }

    const [rows] = await pool.query(query, queryParams);
    return rows as Flight[];
  } catch (error) {
    throw(error);
  }
};

