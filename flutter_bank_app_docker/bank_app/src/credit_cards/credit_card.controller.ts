import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { Credit_CardService } from './credit_card.service';
import { CreateCreditCardDto, UpdateCreditCardDto } from './credit_card.dto';

@Controller('credit_card')
export class Credit_CardController {
  constructor(private readonly credit_cardService: Credit_CardService) {}

  @Get()
  getAllCreditCards(@Query('xml') xml: string) {
    return this.credit_cardService.getAllCreditCards(xml);
  }

  @Get('id/:id')
  getidCreditCard(@Param('id') id: string, @Query('xml') xml: string) {
    return this.credit_cardService.getidCreditCard(parseInt(id), xml);
  }

  @Get('num/:num')
  getCreditCard(@Param('num') num: string) {
    return this.credit_cardService.getCreditCard(parseInt(num));
  }

  @Post()
  createCreditCard(@Body() createCreditCardDto: CreateCreditCardDto) {
    return this.credit_cardService.createCreditCard(createCreditCardDto);
  }

  @Put(':id')
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
  deleteCreditCard(@Param('id') id: string) {
    return this.credit_cardService.deleteCreditCard(parseInt(id));
  }
}
