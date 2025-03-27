import { Accounts } from '../accounts/accounts.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';

@Entity()
export class Accounts_type {
  @PrimaryGeneratedColumn()
  id_type: number;

  @Column()
  description: string;

  @OneToMany(() => Accounts, (accounts) => accounts.accounts_type)
  accounts: Accounts[];
}
