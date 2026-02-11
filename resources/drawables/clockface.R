# Function to generate a clock face circle
generate_clock_face <- function(filename = "clock_face.png",
        width = 260*4,
        height = 260*4,
        diameter_ratio = 1.0,
        line_length = 10*4,
        extended_line_length = 15*4,
        line_thickness = 2*4,
        long_line_thickness = 3*4,
        n_lines = 60) {
  
  # Load required packages
  library(showtext)
  
  # Add Google font
  font_add_google("Roboto Condensed", "robotocondensed")
  showtext_auto()
  
  png(filename, width = width, height = height, bg = "transparent")
  
  par(mar = c(0, 0, 0, 0))
  plot(NULL, xlim = c(0, width), ylim = c(0, height), 
   xlab = "", ylab = "", axes = FALSE, asp = 1)
  
  # Center of the circle
  cx <- width / 2
  cy <- height / 2
  
  # Radius of the circle - full width/height
  radius <- min(width, height) / 2
  
  # Counter for clock numbers (start at 12)
  clock_number <- 12
  
  # Generate lines
  for (i in 0:(n_lines-1)) {
  # Adjust angle to start at top (12 o'clock) and go clockwise
  angle <- (pi / 2) - (i * 2 * pi / n_lines)
  
  # Check if it's line 5, 15, 25, 35, 45, 55 (every 5 minutes)
  is_extended <- (i %% 5 == 0)
  
  # Determine thickness for this line
  current_thickness <- if (is_extended) long_line_thickness else line_thickness
  
  if (is_extended) {
    # Extended lines go outward from the circle
    x_inner <- cx + (radius - extended_line_length) * cos(angle)
    y_inner <- cy + (radius - extended_line_length) * sin(angle)
    x_outer <- cx + radius * cos(angle)
    y_outer <- cy + radius * sin(angle)
      
    # Add clock number more inward with rotation
    text_radius <- radius - extended_line_length - 35
    x_text <- cx + text_radius * cos(angle)
    y_text <- cy + text_radius * sin(angle)
    
    # Hard-code rotation for numbers 4, 5, 6, 7, 8
    if (clock_number %in% c(4, 5, 6, 7, 8)) {
    text_rotation <- angle * 180 / pi + 90
    } else {
    text_rotation <- angle * 180 / pi - 90
    }
    
    text(x_text, y_text, labels = clock_number, 
       cex = 3.0, font = 2, col = "white", family = "robotocondensed",
       srt = text_rotation)
    
    clock_number <- clock_number + 1
    if (clock_number > 12) clock_number <- 1
  } else {
    current_line_length <- line_length
    x_outer <- cx + radius * cos(angle)
    y_outer <- cy + radius * sin(angle)
    x_inner <- cx + (radius - current_line_length) * cos(angle)
    y_inner <- cy + (radius - current_line_length) * sin(angle)
  }
  
  # Draw a rectangle instead of a line
  # Calculate perpendicular direction for rectangle width
  perp_angle <- angle + pi/2
  half_width <- current_thickness / 2
  
  # Calculate the four corners of the rectangle
  x1 <- x_inner + half_width * cos(perp_angle)
  y1 <- y_inner + half_width * sin(perp_angle)
  x2 <- x_inner - half_width * cos(perp_angle)
  y2 <- y_inner - half_width * sin(perp_angle)
  x3 <- x_outer - half_width * cos(perp_angle)
  y3 <- y_outer - half_width * sin(perp_angle)
  x4 <- x_outer + half_width * cos(perp_angle)
  y4 <- y_outer + half_width * sin(perp_angle)
  
  # Draw the rectangle as a filled polygon
  polygon(c(x1, x2, x3, x4), c(y1, y2, y3, y4), 
    col = "white", border = NA)
  }
  
  dev.off()
  message(paste("Clock face saved to", filename))
}

# Generate the clock face with default parameters
generate_clock_face()
