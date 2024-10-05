import express from 'express';
import { getAllTickets, addTicket, payTicket } from '../controllers/ticketController';

const router = express.Router();

router.get('/tickets', getAllTickets);
router.post('/ticket', addTicket);
router.put('/ticket/pay', payTicket);

export default router;
