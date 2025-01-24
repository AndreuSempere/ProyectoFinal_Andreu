import { Accounts } from '../accounts/accounts.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
} from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id_user: number;

  @Column()
  name: string;

  @Column()
  surname: string;

  @Column()
  password: string;

  @Column({ unique: true })
  email: string;

  @Column({ unique: true, nullable: true }) 
  telf?: number | null;  

  @Column({ unique: true, nullable: true })
  dni: string | null;

  @Column()
  age: string;

  @OneToMany(() => Accounts, (accounts) => accounts.id_user)
  accounts: Accounts[];

}
