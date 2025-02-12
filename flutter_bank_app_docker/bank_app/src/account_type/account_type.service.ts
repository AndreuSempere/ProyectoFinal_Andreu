import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UtilsService } from '../utils/utils.service';
import { Accounts_type } from './account_type.entity';
import { CreateAccounts_typeDto, UpdateAccounts_typeDto } from './account_type.dto';

@Injectable()
export class AccountTypeService {
  constructor(
    @InjectRepository(Accounts_type)
    private readonly accountTypeRepository: Repository<Accounts_type>,
    private readonly utilsService: UtilsService,
  ) {}

  async getAllAccountType(format?: string): Promise<any> {
    const accountTypes = await this.accountTypeRepository.find();

    if (format === 'xml') {
      const jsonForXml = JSON.stringify({ Account_types: accountTypes });
      return this.utilsService.convertJSONtoXML(jsonForXml);
    }

    return accountTypes;
  }

  async getAccountType(id_type: number, format?: string): Promise<any> {
    const accountType = await this.accountTypeRepository.findOne({
      where: { id_type: id_type },
    });

    if (!accountType) {
      throw new HttpException(
        'Tipo de cuenta no encontrado',
        HttpStatus.NOT_FOUND,
      );
    }

    if (format === 'xml') {
      const jsonForXml = JSON.stringify({ Account_type: accountType });
      return this.utilsService.convertJSONtoXML(jsonForXml);
    }

    return accountType;
  }

  async createAccountType(
    createAccountTypeDto: CreateAccounts_typeDto,
  ): Promise<{ message: string }> {
    const { description } = createAccountTypeDto;
  
    const newAccountType = this.accountTypeRepository.create({
      description, 
    });
  
    await this.accountTypeRepository.save(newAccountType);
    return { message: 'Tipo de cuenta creado satisfactoriamente' };
  }
  
 async updateAccountType(updateAccountTypeDto: UpdateAccounts_typeDto): Promise<Accounts_type> {
  const accountType = await this.accountTypeRepository.findOne({
    where: { id_type: updateAccountTypeDto.id_type },
  });

  if (!accountType) {
    throw new HttpException(
      'Tipo de cuenta no encontrado',
      HttpStatus.NOT_FOUND,
    );
  }

  await this.accountTypeRepository.update(accountType.id_type, updateAccountTypeDto);
  return this.accountTypeRepository.findOne({ where: { id_type: updateAccountTypeDto.id_type } });
  
}

  async deleteAccountType(id_type: number): Promise<{ message: string }> {
    const result = await this.accountTypeRepository.delete(id_type);

    if (result.affected === 0) {
      throw new HttpException(
        'Tipo de cuenta no encontrado',
        HttpStatus.NOT_FOUND,
      );
    }
    return { message: 'Tipo de cuenta eliminado satisfactoriamente' };
  }
}
