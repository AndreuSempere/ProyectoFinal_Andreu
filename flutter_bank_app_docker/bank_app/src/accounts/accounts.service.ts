import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UtilsService } from '../utils/utils.service';
import { CreateAccoutDto, UpdateAccountDto } from './accounts.dto';
import { Accounts } from './accounts.entity';

@Injectable()
export class AccountsService {
  constructor(
    private readonly utilsService: UtilsService,
    @InjectRepository(Accounts)
    private readonly accountsRepository: Repository<Accounts>,
  ) {}

  async getAccount(id?: number, xml?: string): Promise<any> {
    const result = await this.accountsRepository.findOneBy({
      id_cuenta: id,
    });

    if (xml === 'true') {
      const jsonFormatted = JSON.stringify({
        Account: this.accountsRepository.find(),
      });
      const xmlResult = this.utilsService.convertJSONtoXML(jsonFormatted);
      return xmlResult;
    }

    return result;
  }

  async getAccountAll(xml?: string): Promise<any> {
    const result = await this.accountsRepository.find({
      relations: ['accounts_type', 'user'],
    });
    if (xml === 'true') {
      const jsonFormatted = JSON.stringify({
        Account: result,
      });
      const xmlResult = this.utilsService.convertJSONtoXML(jsonFormatted);
      return xmlResult;
    }

    return result;
  }

  async createAccount(
    createAccountsDto: CreateAccoutDto,
  ): Promise<{ message: string }> {
    const newAccount = this.accountsRepository.create({
      ...createAccountsDto,
      accounts_type: { id_type: createAccountsDto.accounts_type },
      id_user: { id_user: createAccountsDto.id_user },
    });
 
    await this.accountsRepository.save(newAccount);
    return { message: 'Account creada' };
  }

  async updateAccount(id: number, updateAccountsDto: UpdateAccountDto) {
    const accounts = await this.accountsRepository.findOne({
      where: { id_cuenta: id },
      relations: ['accounts_type', 'user'],
    });

    if (!accounts) {
      throw new HttpException('Account no encontrada', HttpStatus.NOT_FOUND);
    }

    const updatedData = {
      ...updateAccountsDto,
      accounts_type: { id_type: updateAccountsDto.accounts_type },
      id_user: { id_user: updateAccountsDto.id_user },
    };

    this.accountsRepository.merge(accounts, updatedData);
    return this.accountsRepository.save(accounts);
  }

  async deleteAccount(id: number): Promise<{ message: string }> {
    const result = await this.accountsRepository.delete(id);
    if (result.affected === 0) {
      throw new HttpException('Account no encontrado', HttpStatus.NOT_FOUND);
    }
    return { message: 'Account eliminado' };
  }

}