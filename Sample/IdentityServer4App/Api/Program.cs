// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.

using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.Title = "API";

            BuildWebHost(args).Run();
        }

        public static IWebHost BuildWebHost(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                   //.UseUrls("http://192.168.1.136:5000")
                   //.UseUrls("http://locahost:5000", "http://192.168.1.136:5000", )
                   //.UseUrls("http://locahost:5000")
                   //.UseUrls("https://macbook-pro-870.local:5000", "https://localhost:5000", "https://192.168.1.136:5000")
                   .UseStartup<Startup>()
                   .Build();
    }
}