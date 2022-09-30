package com.example.demo.services.impl;


import com.example.demo.dto.ImagesOfferDTO;
import com.example.demo.entities.ImagesOffer;
import com.example.demo.mappers.ImagesOfferMapper;
import com.example.demo.repositories.ImagesOfferRepository;
import com.example.demo.services.ImagesOfferService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ImagesOfferServiceImpl implements ImagesOfferService {

    @Autowired
    ImagesOfferRepository imagesOfferRepository;

    @Autowired
    ImagesOfferMapper imagesOfferMapper;

    @Override
    public ImagesOfferDTO save(ImagesOfferDTO imagesOfferDTO) {
        ImagesOffer imagesOffer = imagesOfferMapper.toEntity(imagesOfferDTO);
        imagesOffer = imagesOfferRepository.save(imagesOffer);
        return imagesOfferMapper.toDto(imagesOffer);
    }
}
