import {
  Body,
  Controller,
  Delete,
  Get,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { Credit_CardService } from './credit_card.service';
import { CreateCreditCardDto, UpdateCreditCardDto } from './credit_card.dto';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';

@ApiTags('credit_card')
@Controller('credit_card')
export class Credit_CardController {
  constructor(private readonly credit_cardService: Credit_CardService) {}

  @Get()
  @ApiOperation({ summary: 'Get all credit cards' })
  @ApiResponse({ status: 200, description: 'List of all credit cards.' })
  getAllCreditCards(@Query('xml') xml: string) {
    return this.credit_cardService.getAllCreditCards(xml);
  }

  @Get('id/:id')
  @ApiOperation({ summary: 'Get credit card by ID' })
  @ApiResponse({ status: 200, description: 'Credit card found.' })
  @ApiResponse({ status: 404, description: 'Credit card not found.' })
  getidCreditCard(@Param('id') id: string, @Query('xml') xml: string) {
    return this.credit_cardService.getidCreditCard(parseInt(id), xml);
  }

  @Get('num/:num')
  @ApiOperation({ summary: 'Get credit card by number' })
  @ApiResponse({ status: 200, description: 'Credit card found.' })
  @ApiResponse({ status: 404, description: 'Credit card not found.' })
  async getCreditCard(@Param('num') num: string) {
    const cardNumber = parseInt(num);
    if (isNaN(cardNumber)) {
      throw new NotFoundException('Credit card not found');
    }

    const creditCard = await this.credit_cardService.getCreditCard(cardNumber);
    return creditCard;
  }

  @Post()
  @ApiOperation({ summary: 'Create a new credit card' })
  @ApiResponse({ status: 201, description: 'Credit card created.' })
  @ApiResponse({ status: 400, description: 'Invalid data.' })
  createCreditCard(@Body() createCreditCardDto: CreateCreditCardDto) {
    return this.credit_cardService.createCreditCard(createCreditCardDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update an existing credit card' })
  @ApiResponse({ status: 200, description: 'Credit card updated.' })
  @ApiResponse({ status: 404, description: 'Credit card not found.' })
  updateCreditCard(
    @Param('id') id: string,
    @Body() updateCreditCardDto: UpdateCreditCardDto,
  ) {
    return this.credit_cardService.updateCreditCard(
      parseInt(id),
      updateCreditCardDto,
    );
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a credit card by ID' })
  @ApiResponse({ status: 200, description: 'Credit card deleted.' })
  @ApiResponse({ status: 404, description: 'Credit card not found.' })
  deleteCreditCard(@Param('id') id: string) {
    return this.credit_cardService.deleteCreditCard(parseInt(id));
  }
}
