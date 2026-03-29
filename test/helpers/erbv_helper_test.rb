require "test_helper"

class ErbvHelperTest < ActionView::TestCase
  tests ErbvHelper

  setup do
    @virtual_path = "components/button"
  end

  # erbv_name

  test "erbv_name returns the component name from virtual path" do
    assert_equal "button", erbv_name
  end

  test "erbv_name strips leading underscore from partial name" do
    @virtual_path = "components/_card"
    assert_equal "card", erbv_name
  end

  test "erbv_name returns nil when virtual path is not set" do
    @virtual_path = nil
    assert_nil erbv_name
  end

  # erbv_id

  test "erbv_id returns a scoped identifier using app name and component name" do
    assert_equal "erbv--dummy--button", erbv_id
  end

  # erbv_css_container_query_id

  test "erbv_css_container_query_id returns the same value as erbv_id" do
    assert_equal erbv_id, erbv_css_container_query_id
  end

  # erbv_component_base_selector

  test "erbv_component_base_selector returns a CSS class selector" do
    assert_equal ".erbv--dummy--button", erbv_component_base_selector
  end

  # erbv_html

  test "erbv_html renders a div with the component class by default" do
    output = erbv_html { "content" }
    assert_includes output, "<div"
    assert_includes output, 'class="erbv--dummy--button"'
    assert_includes output, "content"
  end

  test "erbv_html renders a custom tag" do
    output = erbv_html(tag: :section) { "content" }
    assert_includes output, "<section"
  end

  test "erbv_html appends a theme class" do
    output = erbv_html(theme: "dark") { "" }
    assert_includes output, 'class="erbv--dummy--button dark"'
  end

  test "erbv_html renders a style attribute" do
    output = erbv_html(style: "color: red") { "" }
    assert_includes output, 'style="color: red"'
  end

  test "erbv_html renders a lang attribute" do
    output = erbv_html(lang: "en") { "" }
    assert_includes output, 'lang="en"'
  end

  test "erbv_html omits lang attribute when not given" do
    output = erbv_html { "" }
    assert_not_includes output, "lang"
  end

  # erbv_css

  test "erbv_css renders CSS into erbv_css content block" do
    erbv_css { content_tag(:style, ".foo { color: red }") }
    assert_includes content_for(:erbv_css), ".foo { color: red }"
  end

  test "erbv_css only renders once when called multiple times" do
    2.times { erbv_css { content_tag(:style, ".foo {}") } }
    assert_equal 1, content_for(:erbv_css).scan(".foo {}").length
  end

  test "erbv_css adds a container query declaration by default" do
    erbv_css { "" }
    assert_includes content_for(:erbv_css), "container:"
    assert_includes content_for(:erbv_css), "inline-size"
  end

  test "erbv_css skips container query when skip_auto_css_container is true" do
    erbv_css(skip_auto_css_container: true) { "" }
    assert_not_includes content_for(:erbv_css), "container:"
  end

  test "erbv_css uses a custom container type" do
    erbv_css(container_type: "size") { "" }
    assert_includes content_for(:erbv_css), "size"
    assert_not_includes content_for(:erbv_css), "inline-size"
  end

  # erbv_js

  test "erbv_js renders JS into erbv_js content block" do
    erbv_js { content_tag(:script, "console.log('hello')") }
    assert_includes content_for(:erbv_js), "console.log"
  end

  test "erbv_js only renders once when called multiple times" do
    2.times { erbv_js { content_tag(:script, "console.log('hello')") } }
    assert_equal 1, content_for(:erbv_js).scan("console.log").length
  end

  # deduplication is per-component — different components render independently

  test "css deduplication is scoped per component" do
    @virtual_path = "components/button"
    erbv_css { content_tag(:style, ".button {}") }

    @virtual_path = "components/card"
    erbv_css { content_tag(:style, ".card {}") }

    css = content_for(:erbv_css)
    assert_includes css, ".button {}"
    assert_includes css, ".card {}"
  end
end
