export class TicketError extends Error {
  statusCode: number;

  constructor(message: string, statusCode: number) {
    super(message);
    this.statusCode = statusCode;
  }
}

export class InvalidLuggageError extends TicketError {
  constructor() {
    super("Luggage ID is not valid", 400);
  }
}

export class InvalidInsuranceError extends TicketError {
  constructor() {
    super("Insurance ID is not valid", 400);
  }
}

export class InvalidFlightError extends TicketError {
  constructor() {
    super("Flight ID does not exist", 400);
  }
}

export class SeatReservedError extends TicketError {
  constructor() {
    super("Seat has already been reserved for this flight", 400);
  }
}

export class GeneralError extends TicketError {
  constructor(message: string) {
    super(message, 500);
  }
}
