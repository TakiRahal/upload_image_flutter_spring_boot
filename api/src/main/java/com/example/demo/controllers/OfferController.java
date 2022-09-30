package com.example.demo.controllers;

import com.example.demo.dto.OfferDTO;
import com.example.demo.services.OfferService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


@RestController
@RequestMapping("/api/offer/")
@CrossOrigin(origins = "*")
public class OfferController {

    private final Logger log = LoggerFactory.getLogger(OfferController.class);

    @Autowired
    OfferService offerService;

    @PostMapping("/add")
    public ResponseEntity<OfferDTO> createOffer(@RequestBody OfferDTO offerDTO)  {
        log.info("REST request to save Offer : {}", offerDTO);
        OfferDTO result = offerService.save(offerDTO);
        return new ResponseEntity<>(result, HttpStatus.CREATED);
    }

    @PostMapping("upload-images")
    public ResponseEntity<Boolean> publicUploadFiles(@RequestParam("files") List<MultipartFile> multipartFiles, @RequestParam("offerId") Long offerId) {
        log.info("REST request to upload images offer : {} ", offerId);
        Boolean result = offerService.uploadImages(multipartFiles, offerId);
        return ResponseEntity.ok().body(result);
    }


    @GetMapping("/list")
    public ResponseEntity<Page<OfferDTO>> getAllOffers(Pageable pageable)  {
        log.info("REST request to get all Offers : {}");
        Page<OfferDTO> result = offerService.fetchOffers(pageable);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("image/{offerId}/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> getFile(@PathVariable Long offerId, @PathVariable String filename) {
        Resource file = offerService.loadFile(offerId, filename);
        if(file!=null){
            return ResponseEntity
                    .ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
                    .body(file);
        }
        else{
            return ResponseEntity
                    .ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=")
                    .body(null);
        }
    }
}
