package com.proyecto.spring.repository;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.proyecto.spring.entity.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

	 @EntityGraph(attributePaths = "accounts")
	 Optional<User> findByTelf(String telf);

}
