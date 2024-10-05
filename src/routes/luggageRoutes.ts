import express from 'express';
import {getAllLuggages} from '../controllers/luggageController';

const router = express.Router();

router.get('/luggages',getAllLuggages);

export default router;