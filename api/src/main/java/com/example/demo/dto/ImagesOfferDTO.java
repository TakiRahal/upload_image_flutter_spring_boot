package com.example.demo.dto;

import lombok.*;

import java.io.Serializable;

@Getter
@Setter
public class ImagesOfferDTO implements Serializable {
    private Long id;
    private String name;
    private OfferDTO offer;
}
