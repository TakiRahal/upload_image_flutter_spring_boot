package com.example.demo.services.impl;


import com.example.demo.dto.ImagesOfferDTO;
import com.example.demo.dto.OfferDTO;
import com.example.demo.entities.Offer;
import com.example.demo.mappers.OfferMapper;
import com.example.demo.repositories.ImagesOfferRepository;
import com.example.demo.repositories.OfferRepository;
import com.example.demo.services.ImagesOfferService;
import com.example.demo.services.OfferService;
import com.example.demo.services.StorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
public class OfferServiceImpl implements OfferService {

    @Autowired
    OfferRepository offerRepository;

    @Autowired
    OfferMapper offerMapper;

    @Autowired
    ImagesOfferService imagesOfferService;

    @Autowired
    StorageService storageService;

    @Autowired
    ImagesOfferRepository imagesOfferRepository;

    @Override
    public OfferDTO save(OfferDTO offerDTO) {
        Offer offer = offerMapper.toEntity(offerDTO);
        offer = offerRepository.save(offer);

        for (ImagesOfferDTO imagesOfferDTO: offerDTO.getImagesOffer()
             ) {
            imagesOfferDTO.setOffer(offerMapper.toDto(offer));
            imagesOfferService.save(imagesOfferDTO);
        }

        return offerMapper.toDto(offer);
    }

    @Override
    public Boolean uploadImages(List<MultipartFile> multipartFiles, Long offerId) {
        String pathAddProduct = storageService.getBaseStorageProductImages() + offerId;

        for(MultipartFile file : multipartFiles) {
            Path rootLocation = Paths.get(pathAddProduct);
            if (storageService.existPath(pathAddProduct)) { // Upload for Update offer
                storageService.store(file, rootLocation);
            } else { // Upload for new offer
                storageService.init(pathAddProduct);
                storageService.store(file, rootLocation);
            }
        }

        return null;
    }

    @Override
    public Page<OfferDTO> fetchOffers(Pageable pageable) {
        return offerRepository.findAll(pageable).map(offerMapper::toDto);
    }

    @Override
    public Resource loadFile(Long offerId, String filename) {
        Path rootLocation = Paths.get(storageService.getBaseStorageProductImages() + offerId);
        return  storageService.loadFile(filename, rootLocation);
    }
}
