library(showtext)

generate_clock_face_display <- function(filename = "clock_face.png",
                                        width = 260*4,
                                        height = 260*4,
                                        diameter_ratio = 1.08,
                                        line_length = 10*4,
                                        extended_line_length = 15*4,
                                        longer_line_length = 100*4,
                                        line_thickness = 2*4,
                                        long_line_thickness = 3*4,
                                        longer_line_thickness = 1.5*4,
                                        n_lines = 60) {
  
  font_add_google("Roboto Condensed", "robotocondensed")
  showtext_auto()
  
  draw_face <- function() {
    par(mar = c(0, 0, 0, 0), bg = "black")
    plot(NULL, xlim = c(0, width), ylim = c(0, height),
         xlab = "", ylab = "", axes = FALSE, asp = 1)
    
    cx <- width / 2
    cy <- height / 2
    radius <- min(width, height) / 2 * diameter_ratio
    clock_number <- 12
    
    for (i in 0:(n_lines-1)) {
      angle <- (pi / 2) - (i * 2 * pi / n_lines)
      is_extended <- (i %% 5 == 0)
      is_major_hour <- ((i+5) %% 10 == 0)
      is_longer_hour <- ((i) %% 10 == 0)
      current_thickness <- if (is_extended) long_line_thickness else line_thickness
      current_thickness <- if (is_longer_hour) longer_line_thickness else current_thickness
      
      if (is_major_hour) {
        x_inner <- cx + (radius - extended_line_length) * cos(angle)
        y_inner <- cy + (radius - extended_line_length) * sin(angle)
        x_outer <- cx + radius * cos(angle)
        y_outer <- cy + radius * sin(angle)
        
        text_radius <- radius - extended_line_length - 48
        x_text <- cx + text_radius * cos(angle)
        y_text <- cy + text_radius * sin(angle)
        
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
      } else if (is_extended) {
        len <- if (is_longer_hour) longer_line_length else extended_line_length
        x_inner <- cx + (radius - len) * cos(angle)
        y_inner <- cy + (radius - len) * sin(angle)
        x_outer <- cx + radius * cos(angle)
        y_outer <- cy + radius * sin(angle)
        
        clock_number <- clock_number + 1
        if (clock_number > 12) clock_number <- 1
      } else {
        x_inner <- cx + (radius - line_length) * cos(angle)
        y_inner <- cy + (radius - line_length) * sin(angle)
        x_outer <- cx + radius * cos(angle)
        y_outer <- cy + radius * sin(angle)
      }
      
      perp_angle <- angle + pi/2
      half_width <- current_thickness / 2
      
      x1 <- x_inner + half_width * cos(perp_angle)
      y1 <- y_inner + half_width * sin(perp_angle)
      x2 <- x_inner - half_width * cos(perp_angle)
      y2 <- y_inner - half_width * sin(perp_angle)
      x3 <- x_outer - half_width * cos(perp_angle)
      y3 <- y_outer - half_width * sin(perp_angle)
      x4 <- x_outer + half_width * cos(perp_angle)
      y4 <- y_outer + half_width * sin(perp_angle)
      
      polygon(c(x1, x2, x3, x4), c(y1, y2, y3, y4),
              col = "white", border = NA)
      
      if (i == 0) {
        twelve_gap <- (2 * pi / n_lines) / 3  # closer to 12 (smaller = closer)
        for (side in c(-1, 1)) {
          a <- angle + side * twelve_gap
          xi <- cx + (radius - extended_line_length) * cos(a)
          yi <- cy + (radius - extended_line_length) * sin(a)
          xo <- cx + radius * cos(a)
          yo <- cy + radius * sin(a)
          pa <- a + pi/2
          hw <- line_thickness / 2
          polygon(
            c(xi + hw*cos(pa), xi - hw*cos(pa), xo - hw*cos(pa), xo + hw*cos(pa)),
            c(yi + hw*sin(pa), yi - hw*sin(pa), yo - hw*sin(pa), yo + hw*sin(pa)),
            col = "white", border = NA
          )
        }
      }
    }
  }
  
  # Save to PNG
  png(filename, width = width, height = height, bg = "transparent")
  draw_face()
  dev.off()
  message(paste("Clock face saved to", filename))
  
  # Also render to the active plot window
  draw_face()
}

generate_clock_face_display()