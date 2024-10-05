import { Request, Response } from "express";
import { getLuggages } from "../services/luggageService";

export const getAllLuggages = async (req: Request, res: Response) => {
  try {
    const luggages = await getLuggages();
    res.json(luggages);
  } catch (error) {
    res.status(500).json({ message: "Error fetching luggages" });
  }
};
