package com.example.demo.dto;

import lombok.*;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
public class OfferDTO implements Serializable {
    private Long id;
    private String title;
    private String description;
    private Set<ImagesOfferDTO> imagesOffer = new HashSet<>();
}
