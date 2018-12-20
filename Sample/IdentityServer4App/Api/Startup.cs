// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.

using System.Net.Http;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Api.Domain;

namespace Api
{
    public class Startup
    {
        //BEGIN: Added RPB
        public IConfiguration Configuration { get; }
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        //END

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvcCore()
                .AddAuthorization()
                .AddJsonFormatters();

            services.AddAuthentication("Bearer")
                .AddIdentityServerAuthentication(options =>
                {
                    //options.Authority = "https://localhost:5001";
                    options.Authority = "http://localhost:5001";


                    //options.Authority = "https://localhost:44380/"; //ASPNet 2.1 is running all it's stuff on SSL
                    options.RequireHttpsMetadata = false;

                    options.ApiName = "api1";
                });

            //Added RPB3 for Profile Support
            services.AddTransient<IProfileRepository, ProfileRepository>();
        }

        public void Configure(IApplicationBuilder app)
        {
            //Added for Docker Proxy
            //app.UseForwardedHeaders(new ForwardedHeadersOptions
            //{
            //    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
            //});

            app.UseAuthentication();

            app.UseMvc();

            //https://github.com/dotnet/corefx/issues/19709
            //https://github.com/dotnet/corefx/issues/25072

            //var handler = new HttpClientHandler();
            //handler.ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator;
        }
    }
}