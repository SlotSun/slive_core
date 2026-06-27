use flutter_rust_bridge::frb;

/// Mirrors `LiveMessageColor` from the reference.
#[derive(Debug, Clone)]
pub struct LiveMessageColor {
    pub r: i32,
    pub g: i32,
    pub b: i32,
}

impl LiveMessageColor {
    #[frb(sync)]
    pub fn white() -> Self {
        Self { r: 255, g: 255, b: 255 }
    }

    #[frb(sync)]
    pub fn from_int(int_color: i32) -> Self {
        let obj = format!("{int_color:06x}");
        if obj.len() == 6 {
            let r = i32::from_str_radix(&obj[0..2], 16).unwrap_or(255);
            let g = i32::from_str_radix(&obj[2..4], 16).unwrap_or(255);
            let b = i32::from_str_radix(&obj[4..6], 16).unwrap_or(255);
            Self { r, g, b }
        } else if obj.len() == 8 {
            let r = i32::from_str_radix(&obj[2..4], 16).unwrap_or(255);
            let g = i32::from_str_radix(&obj[4..6], 16).unwrap_or(255);
            let b = i32::from_str_radix(&obj[6..8], 16).unwrap_or(255);
            Self { r, g, b }
        } else {
            Self::white()
        }
    }

    #[frb(sync)]
    pub fn to_hex(&self) -> String {
        format!("#{:02x}{:02x}{:02x}", self.r, self.g, self.b)
    }
}
