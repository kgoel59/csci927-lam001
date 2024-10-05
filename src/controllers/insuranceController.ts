import { Request, Response } from "express";
import { getInsurances } from "../services/insuranceService";

export const getAllInsurances = async (req: Request, res: Response) => {
  try {
    const insurances = await getInsurances();
    res.json(insurances);
  } catch (error) {
    res.status(500).json({ message: "Error fetching insurancess" });
  }
};
