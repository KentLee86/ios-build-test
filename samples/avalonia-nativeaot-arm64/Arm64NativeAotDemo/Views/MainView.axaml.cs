using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using Avalonia.Controls;
using Avalonia.Media;

namespace Arm64NativeAotDemo.Views;

public sealed partial class MainView : UserControl
{
    private bool _evidenceWritten;

    public MainView()
    {
        InitializeComponent();

        var isNativeAot = !RuntimeFeature.IsDynamicCodeSupported;
        ArchitectureText.Text = RuntimeInformation.ProcessArchitecture.ToString().ToUpperInvariant();
        RuntimeModeText.Text = isNativeAot ? "NATIVE AOT" : "JIT / DEV";
        RuntimeIdentifierText.Text = RuntimeInformation.RuntimeIdentifier;
        FrameworkText.Text = RuntimeInformation.FrameworkDescription;
        StatusText.Text = isNativeAot ? "NATIVEAOT READY" : "DEVELOPMENT BUILD";

        if (!isNativeAot)
        {
            StatusBadge.Background = new SolidColorBrush(Color.Parse("#3B2D13"));
            StatusBadge.BorderBrush = new SolidColorBrush(Color.Parse("#8B6D22"));
            StatusText.Foreground = new SolidColorBrush(Color.Parse("#F5D879"));
        }

        AttachedToVisualTree += (_, _) => WriteRuntimeEvidence();
    }

    private void WriteRuntimeEvidence()
    {
        if (_evidenceWritten)
        {
            return;
        }

        _evidenceWritten = true;

        var evidencePath = Environment.GetEnvironmentVariable("AVALONIA_EVIDENCE_FILE");
        if (!string.IsNullOrWhiteSpace(evidencePath))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(evidencePath) ?? ".");
            File.WriteAllLines(evidencePath,
            [
                $"process_architecture={RuntimeInformation.ProcessArchitecture}",
                $"os_architecture={RuntimeInformation.OSArchitecture}",
                $"runtime_identifier={RuntimeInformation.RuntimeIdentifier}",
                $"framework={RuntimeInformation.FrameworkDescription}",
                $"dynamic_code_supported={RuntimeFeature.IsDynamicCodeSupported.ToString().ToLowerInvariant()}",
                $"dynamic_code_compiled={RuntimeFeature.IsDynamicCodeCompiled.ToString().ToLowerInvariant()}",
            ]);
        }

        var readyPath = Environment.GetEnvironmentVariable("AVALONIA_READY_FILE");
        if (!string.IsNullOrWhiteSpace(readyPath))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(readyPath) ?? ".");
            File.WriteAllText(readyPath, "ready\n");
        }
    }
}
