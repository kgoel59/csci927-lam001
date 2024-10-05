import pool from "../config/db";
import {Luggage} from "../models/Luggage";

export const getLuggages = async ():Promise<Luggage[]>=>{
    try{
        const query = 'SELECT * FROM Luggage';
        const [rows] = await pool.query(query);
        return rows as Luggage[];
    }
    catch(error){
        throw(error);
    }
}