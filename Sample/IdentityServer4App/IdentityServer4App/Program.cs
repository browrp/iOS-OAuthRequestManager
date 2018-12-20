using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;
using Serilog.Sinks.SystemConsole.Themes;

namespace IdentityServer4App
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Debug()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .MinimumLevel.Override("System", LogEventLevel.Warning)
            .MinimumLevel.Override("Microsoft.AspNetCore.Authentication", LogEventLevel.Information)
            .Enrich.FromLogContext()
            .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level}] {SourceContext}{NewLine}{Message:lj}{NewLine}{Exception}{NewLine}", theme: AnsiConsoleTheme.Literate)
            .CreateLogger();
            
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                   //.UseKestrel(options => {
                   //    //Overrides the default settings binding the development server to localhost:5001
                   //    //Make sure to also update Project Options > Run > Configurations > Default > ASP.NET Core > App URL. You'll need to close / re-open the solution for the settings to take effect.
                   //    options.Listen(IPAddress.Any, 5001);
                   //})
                   //.UseUrls("https://localhost:5001", "https://192.168.1.136:5001")
                   //.UseUrls("https://locahost:5001", "https://192.168.1.136:5001")
                   //.UseUrls("https://locahost:5001")
                   .UseStartup<Startup>()
                    /*
                   .UseKestrel(options =>
                   {

                       options.ListenAnyIP(5001);
                       
                   })
                   */                 
                   .UseSerilog();
                   //.Build();
    }
}
