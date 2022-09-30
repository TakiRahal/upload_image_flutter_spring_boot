package com.example.demo.mappers;

import com.example.demo.dto.OfferDTO;
import com.example.demo.entities.Offer;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = { ImagesOfferMapper.class })
public interface OfferMapper extends EntityMapper<OfferDTO, Offer> {

    @Mapping(target = "imagesOffer", source = "imagesOffer", qualifiedByName = "idSet")
    OfferDTO toDto(Offer entity);
}
