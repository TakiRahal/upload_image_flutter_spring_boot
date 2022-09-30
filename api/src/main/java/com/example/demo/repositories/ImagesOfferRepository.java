package com.example.demo.repositories;

import com.example.demo.entities.ImagesOffer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ImagesOfferRepository extends JpaRepository<ImagesOffer, Long> {
}
