export interface Flight {
  flight_id: number;
  departure_time: string;
  arrival_time: string;
  departure_airport_code: string;
  arrival_airport_code: string;
  price: number;
  currency: string;
  aircraft_id: number;
  model: string;
  start_row_letter: string;
  end_row_letter: string;
  seat_per_row: number;
  provider_name: string;
  provider_country: string;
}
