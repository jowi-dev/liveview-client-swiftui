defmodule Mix.Tasks.Lvn.Swiftui.GenTest do
  use ExUnit.Case

  import Mix.Lvn.TestHelper
  import ExUnit.CaptureIO

  alias Mix.Tasks.Lvn.Swiftui.Gen

  @macos? :os.type() == {:unix, :darwin}

  setup do
    Mix.Task.clear()
    :ok
  end

  describe "when a single app" do
    test "copies the core components file into the project and generates a new xcode project",
         config do
      in_tmp_live_project(config.test, fn ->
        capture_io(fn ->
          Gen.run([])
        end)

        assert_file(
          "lib/live_view_native_swiftui_web/components/core_components.swiftui.ex",
          fn file ->
            assert file =~ "LiveViewNativeSwiftuiWeb.CoreComponents.SwiftUI"
            assert file =~ "import LiveViewNative.LiveForm.Component"
          end
        )

        if @macos? do
          assert_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
        end
      end)
    end

    test "when --no-live-form copies the core components file without LiveForm components into the project and generates a new xcode project",
         config do
      in_tmp_live_project(config.test, fn ->
        capture_io(fn ->
          Gen.run(["--no-live-form"])
        end)

        assert_file(
          "lib/live_view_native_swiftui_web/components/core_components.swiftui.ex",
          fn file ->
            assert file =~ "LiveViewNativeSwiftuiWeb.CoreComponents.SwiftUI"
            refute file =~ "import LiveViewNative.LiveForm.Component"
          end
        )

        if @macos? do
          assert_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
        end
      end)
    end

    test "when --no-copy does not copy the core components file into the project but does generates a new xcode project",
         config do
      in_tmp_live_project(config.test, fn ->
        capture_io(fn ->
          Gen.run(["--no-copy"])
        end)

        refute_file("lib/live_view_native_swiftui_web/components/core_components.swiftui.ex")

        if @macos? do
          assert_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
        end
      end)
    end

    test "when --no-xcodegen copies the core components file into the project but does not generate a new xcode project",
         config do
      in_tmp_live_project(config.test, fn ->
        capture_io(fn ->
          Gen.run(["--no-xcodegen"])
        end)

        assert_file("lib/live_view_native_swiftui_web/components/core_components.swiftui.ex")

        if @macos? do
          refute_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
        end
      end)
    end

    test "when --no-notify copies core components file into the project but does not include AppDelegate.swift",
         config do
      in_tmp_live_project(config.test, fn ->
        capture_io(fn ->
          Gen.run(["--no-notify"])
        end)

        assert_file("lib/live_view_native_swiftui_web/components/core_components.swiftui.ex")

        if @macos? do
          refute_file("native/swiftui/LiveViewNativeSwiftui/AppDelegate.swift")

          assert_file(
            "native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift",
            fn file ->
              refute file =~ "@UIApplicationDelegateAdaptor(AppDelegate.self)"
            end
          )
        end
      end)
    end
  end

  describe "when an umbrella app" do
    test "copies the core components file into the project and generates a new xcode project",
         config do
      in_tmp_live_umbrella_project(config.test, fn ->
        File.cd!("live_view_native_swiftui_web", fn ->
          capture_io(fn ->
            Gen.run([])
          end)

          assert_file(
            "lib/live_view_native_swiftui_web/components/core_components.swiftui.ex",
            fn file ->
              assert file =~ "LiveViewNativeSwiftuiWeb.CoreComponents.SwiftUI"
              assert file =~ "import LiveViewNative.LiveForm.Component"
            end
          )

          if @macos? do
            assert_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
          end
        end)
      end)
    end

    test "when --no-live-form copies the core components file without LiveForm components into the project and generates a new xcode project",
         config do
      in_tmp_live_umbrella_project(config.test, fn ->
        File.cd!("live_view_native_swiftui_web", fn ->
          capture_io(fn ->
            Gen.run(["--no-live-form"])
          end)

          assert_file(
            "lib/live_view_native_swiftui_web/components/core_components.swiftui.ex",
            fn file ->
              assert file =~ "LiveViewNativeSwiftuiWeb.CoreComponents.SwiftUI"
              refute file =~ "import LiveViewNative.LiveForm.Component"
            end
          )

          if @macos? do
            assert_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
          end
        end)
      end)
    end

    test "when --no-copy does not copy the core components file into the project but does generates a new xcode project",
         config do
      in_tmp_live_umbrella_project(config.test, fn ->
        File.cd!("live_view_native_swiftui_web", fn ->
          capture_io(fn ->
            Gen.run(["--no-copy"])
          end)

          refute_file("lib/live_view_native_swiftui_web/components/core_components.swiftui.ex")

          if @macos? do
            assert_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
          end
        end)
      end)
    end

    test "when --no-xcodegen copies the core components file into the project but does not generate a new xcode project",
         config do
      in_tmp_live_umbrella_project(config.test, fn ->
        File.cd!("live_view_native_swiftui_web", fn ->
          capture_io(fn ->
            Gen.run(["--no-xcodegen"])
          end)

          assert_file("lib/live_view_native_swiftui_web/components/core_components.swiftui.ex")

          if @macos? do
            refute_file("native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift")
          end
        end)
      end)
    end
  end
end
