using AutoMapper;
using backend.Dtos;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Helpers
{
    public class AutoMapperProfile: Profile
    {
        public AutoMapperProfile()
        {
            CreateMap<ProductDto, Product>();
            CreateMap<Product, ProductDto>();

            CreateMap<CatalogDto, Catalog>();
            CreateMap<Catalog, CatalogDto>();

            CreateMap<CategoryDto, Category>();
            CreateMap<Category, CategoryDto>();

            CreateMap<PostDto, Post>();
            CreateMap<Post, PostDto>();
        }
    }
}
