import express from "express";
import { getAllFlights } from "../controllers/flightController";

const router = express.Router();

router.get("/flights", getAllFlights);

export default router;
