import { Credit_Card } from '../credit_cards/credit_card.entity';
import { Accounts_type } from '../account_type/account_type.entity';
import { User } from '../users/users.entity';
import { Transaction } from '../transactions/transactions.entity';
import { Investment } from '../investments/investments.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  JoinColumn,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
} from 'typeorm';

@Entity()
export class Accounts {
  @PrimaryGeneratedColumn()
  id_cuenta: number;

  @Column({ type: 'varchar', length: 34, unique: true })
  numero_cuenta: string;

  @Column()
  saldo: number;

  @Column()
  estado: string;

  @Column()
  description: string;

  @Column()
  icon: string;

  @CreateDateColumn({ type: 'timestamp' })
  fecha_creacion: Date;

  @ManyToOne(() => Accounts_type, (accounts_type) => accounts_type.accounts, {
    nullable: false,
  })
  @JoinColumn({ name: 'id_type' })
  accounts_type: Accounts_type;

  @ManyToOne(() => User, (user) => user.accounts)
  @JoinColumn({ name: 'id_user' })
  id_user: User;

  @OneToMany(() => Credit_Card, (credit_card) => credit_card.accounts, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  credit_card: Credit_Card[];

  @OneToMany(() => Transaction, (transaction) => transaction.account, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  transactions: Transaction[];

  @OneToMany(() => Investment, (investment) => investment.account, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  investments: Investment[];
}
