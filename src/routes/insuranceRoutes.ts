import express from 'express';
import {getAllInsurances} from '../controllers/insuranceController';

const router = express.Router();

router.get('/insurances',getAllInsurances);

export default router;