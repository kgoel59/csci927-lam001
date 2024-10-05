import pool from "../config/db";
import {Insurance} from "../models/Insurance";

export const getInsurances = async ():Promise<Insurance[]>=>{
    try{
        const query = 'SELECT * FROM Insurance'
        const [rows] = await pool.query(query);
        return rows as Insurance[];
    }
    catch(error){
        throw(error);
    }
}