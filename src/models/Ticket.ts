export interface Ticket {
  ticket_id: number;
  email: string;
  first_name: string | null;
  last_name: string | null;
  created_date: string;
  paid_status: boolean;
  paid_date: string;
  departure_time: string;
  arrival_time: string;
  departure_airport_code: string;
  arrival_airport_code: string;
  seat_name: string;
  seat_price: number;
  seat_type: string;
  luggage_type_id: number | null;
  insurance_type_id: number | null;
}
