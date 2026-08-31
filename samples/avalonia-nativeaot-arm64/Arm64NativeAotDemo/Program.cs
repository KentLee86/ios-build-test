using Avalonia;
using Avalonia.LinuxFramebuffer;

namespace Arm64NativeAotDemo;

internal static class Program
{
    [STAThread]
    public static int Main(string[] args)
    {
        var builder = BuildAvaloniaApp();

        if (args.Contains("--drm", StringComparer.Ordinal))
        {
            return builder.StartLinuxDrm(args, card: null, options: new DrmOutputOptions
            {
                Scaling = 1.0,
            });
        }

        return builder.StartWithClassicDesktopLifetime(args);
    }

    public static AppBuilder BuildAvaloniaApp() =>
        AppBuilder.Configure<App>()
            .UsePlatformDetect()
            .LogToTrace();
}
