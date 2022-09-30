package com.example.demo.services;


import com.example.demo.dto.OfferDTO;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface OfferService {

    /**
     *
     * @param offerDTO
     * @return
     */
    OfferDTO save(OfferDTO offerDTO);

    /**
     *
     * @param multipartFiles
     * @param offerId
     * @return
     */
    Boolean uploadImages(List<MultipartFile> multipartFiles, Long offerId);

    /**
     *
     * @return
     */
    Page<OfferDTO> fetchOffers(Pageable pageable);

    Resource loadFile(Long offerId, String filename);
}
