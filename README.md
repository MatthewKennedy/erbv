# Erbv

Erbv is a Rails engine that provides helper methods for building reusable, self-contained view components in plain ERB. It gives each component a stable, scoped identifier and handles deduplication of CSS and JavaScript so styles and scripts are only rendered once per page, even when a component is used multiple times.

## Installation

Add to your Gemfile:

```ruby
gem "erbv"
```

Then run:

```bash
bundle install
```

## Setup

Yield the erbv content blocks in your application layout:

```erb
<!DOCTYPE html>
<html>
  <head>
    <%= yield :erbv_css %>
  </head>
  <body>
    <%= yield %>
    <%= yield :erbv_js %>
  </body>
</html>
```

## Usage

Erbv helpers are available in all ERB partials. A typical component partial looks like this:

```erb
<%# app/views/components/_button.html.erb %>

<% erbv_css do %>
  <style>
    <%= erbv_component_base_selector %> {
      /* scoped styles */
      background: blue;
      color: white;
    }
  </style>
<% end %>

<% erbv_js do %>
  <script>
    // scoped JavaScript, rendered once per page
  </script>
<% end %>

<%= erbv_html do %>
  <%= content %>
<% end %>
```

## Helpers

### `erbv_id`

Returns a unique identifier for the component based on the application name and the component's filename.

```
"erbv--myapp--button"
```

### `erbv_name`

Returns just the component name derived from the ERB partial filename (with the leading underscore removed).

```
"button"
```

### `erbv_component_base_selector`

Returns a CSS class selector string for the component.

```
".erbv--myapp--button"
```

### `erbv_css(skip_auto_css_container: false, container_type: "inline-size")`

Renders a CSS block into `:erbv_css` content. The block is only rendered once per page regardless of how many times the component is used.

By default it also outputs a container query declaration scoped to the component. Pass `skip_auto_css_container: true` to disable this, or `container_type:` to use a different container type.

### `erbv_js`

Renders a JavaScript block into `:erbv_js` content. Like `erbv_css`, the block is only rendered once per page.

### `erbv_html(tag: :div, theme: nil, style: nil, lang: nil)`

Renders an HTML container element with the component's scoped class automatically applied. Pass `theme:` to append additional class names, `style:` for inline styles, and `lang:` for a lang attribute.

```erb
<%= erbv_html(tag: :section, theme: "dark", lang: "en") do %>
  ...
<% end %>
```

Renders as:

```html
<section class="erbv--myapp--button dark" lang="en">
  ...
</section>
```

## License

MIT
