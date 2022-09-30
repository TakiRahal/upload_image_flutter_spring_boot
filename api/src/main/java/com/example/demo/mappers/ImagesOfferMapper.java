package com.example.demo.mappers;

import com.example.demo.dto.ImagesOfferDTO;
import com.example.demo.entities.ImagesOffer;
import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

import java.util.Set;

@Mapper(componentModel = "spring", uses = { })
public interface ImagesOfferMapper extends EntityMapper<ImagesOfferDTO, ImagesOffer>  {

    @Mapping(target = "offer", ignore = true)
    ImagesOfferDTO toDto(ImagesOffer imagesOffer);

    @Named("idSet")
    @BeanMapping(ignoreByDefault = true)
    @Mapping(target = "id", source = "id")
    Set<ImagesOfferDTO> toDtoIdSet(Set<ImagesOffer> imagesOffers);

}
