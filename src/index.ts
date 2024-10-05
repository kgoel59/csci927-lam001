import express, { Request, Response, NextFunction } from 'express';
import {TicketError} from './errors/ticketError'
import dotenv from 'dotenv';
import flightRoutes from './routes/flightRoutes';
import luggageRoutes from './routes/luggageRoutes';
import insuranceRoutes from './routes/insuranceRoutes';
import ticketRoutes from './routes/ticketRoutes';
dotenv.config();

const app = express();
app.use(express.json());

// flight apis
app.use('/api', flightRoutes);
// luggage apis
app.use('/api', luggageRoutes);
// insurance apis
app.use('/api', insuranceRoutes);
// ticket apis
app.use('/api', ticketRoutes);

// Error-handling middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  if (res.headersSent) {
      return next(err);  // Delegate to default Express error handler
  }

  if (err instanceof TicketError) {
      return res.status(err.statusCode).json({ error: err.message });
  }

  // Handle any other unknown errors
  return res.status(500).json({ error: 'An unexpected error occurred' });
});
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
