import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository } from 'typeorm';
import { UtilsService } from '../utils/utils.service';
import { CreateCreditCardDto, UpdateCreditCardDto } from './credit_card.dto';
import { Credit_Card } from './credit_card.entity';
import { Accounts } from '../accounts/accounts.entity';

@Injectable()
export class Credit_CardService {
  constructor(
    private readonly utilsService: UtilsService,
    @InjectRepository(Credit_Card)
    private readonly creditCardRepository: Repository<Credit_Card>,
    @InjectRepository(Accounts) 
    private readonly accountsRepository: Repository<Accounts>,
  ) {}

  async getidCreditCard(id: number, xml?: string): Promise<any> {
    const result = await this.creditCardRepository.findOne({
      where: { id_tarjeta: id },
      relations: ['accounts'],
    });

    if (!result) {
      throw new HttpException('Tarjeta no encontrada', HttpStatus.NOT_FOUND);
    }

    if (xml === 'true') {
      const jsonFormatted = JSON.stringify({
        CreditCard: result,
      });
      return this.utilsService.convertJSONtoXML(jsonFormatted);
    }

    return result;
  }

  async getCreditCard(num: number): Promise<any> {
    const result = await this.creditCardRepository.findOne({
      where: { numero_tarjeta: num },
      relations: ['accounts'],
    });
    
    if (!result) {
      throw new Error("Tarjeta no encontrada");
    }
    
    return result;
    
  }

  async getAllCreditCards(xml?: string): Promise<any> {
    const result = await this.creditCardRepository.find({
      relations: ['accounts'],
    });

    if (xml === 'true') {
      const jsonFormatted = JSON.stringify({
        CreditCards: result,
      });
      return this.utilsService.convertJSONtoXML(jsonFormatted);
    }

    return result;
  }

  async createCreditCard(
    createCreditCardDto: CreateCreditCardDto,
  ): Promise<{ message: string }> {
    const existingCard = await this.creditCardRepository.findOne({
      where: { numero_tarjeta: createCreditCardDto.numero_tarjeta },
    });

    if (existingCard) {
      throw new HttpException(
        'El número de tarjeta ya existe',
        HttpStatus.BAD_REQUEST,
      );
    }
    const accountExists = await this.accountsRepository.findOne({
      where: { id_cuenta: createCreditCardDto.id_cuenta },
    });

    if (!accountExists) {
      throw new HttpException(
        'La cuenta no existe',
        HttpStatus.BAD_REQUEST,
      );
    }

    const newCreditCard = this.creditCardRepository.create({
      ...createCreditCardDto,
      accounts: { id_cuenta: createCreditCardDto.id_cuenta },
    });

    await this.creditCardRepository.save(newCreditCard);
    return { message: 'Tarjeta de crédito creada exitosamente' };
  }

  async updateCreditCard(id: number, updateCreditCardDto: UpdateCreditCardDto) {
    const creditCard = await this.creditCardRepository.findOne({
      where: { id_tarjeta: id },
      relations: ['accounts'],
    });

    if (!creditCard) {
      throw new HttpException('Tarjeta no encontrada', HttpStatus.NOT_FOUND);
    }

    if (updateCreditCardDto.numero_tarjeta) {
      const existingCard = await this.creditCardRepository.findOne({
        where: { 
          numero_tarjeta: updateCreditCardDto.numero_tarjeta,
          id_tarjeta: Not(id),
        },
      });

      if (existingCard) {
        throw new HttpException(
          'El número de tarjeta ya existe',
          HttpStatus.BAD_REQUEST,
        );
      }
    }

    const updatedData = {
      ...updateCreditCardDto,
      accounts: updateCreditCardDto.id_cuenta
        ? { id_cuenta: updateCreditCardDto.id_cuenta }
        : creditCard.accounts,
    };

    this.creditCardRepository.merge(creditCard, updatedData);
    const updatedCard = await this.creditCardRepository.save(creditCard);
    return updatedCard;
  }

  async deleteCreditCard(id: number): Promise<{ message: string }> {
    const result = await this.creditCardRepository.delete(id);
    
    if (result.affected === 0) {
      throw new HttpException('Tarjeta no encontrada', HttpStatus.NOT_FOUND);
    }
    
    return { message: 'Tarjeta eliminada exitosamente' };
  }
}
