import { Request, Response } from "express";
import { getFlights } from "../services/flightService";
export interface GetFlightsParam {
  departure_time: string;
  arrival_time?:string;
  departure_airport_code:string;
  arrival_airport_code:string
  is_round_trip?: boolean
}
export const getAllFlights = async (req: Request<{},{},{},GetFlightsParam>, res: Response) => {
  // Extract query parameters
  const {
    departure_time,    
    departure_airport_code,
    arrival_airport_code,    
  } = req.query;
  if (!departure_time || !departure_airport_code || !arrival_airport_code) {
    return res
      .status(400)
      .json({
        message: "departure_time and departure_airport_code and arrival_airport_code are required",
      });
  }

  try {
    
    const flights = await getFlights(req.query);
    res.json(flights);
  } catch (error) {
    res.status(500).json({ message: "Error fetching flights" });
  }
};


