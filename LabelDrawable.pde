class LabelDrawable implements Drawable {
	private final int lalign, ralign;
	private float x, y;
	private PFont font;
	private String text;
	LabelDrawable(String text, int lalign, int ralign, PFont font) {
		this.text = text;
		this.lalign = lalign;
		this.ralign = ralign;
		this.font = font;
	}

	public void place(Point p) {
		this.x = p.x;
		this.y = p.y;
	}

	public float getWidth() {
		// reserve entire line
		return width;
	}

	public float getHeight() {
		return 30f; // ??????????
	}

	public void setup() { }
	public void tick() { }
	
	public void draw() {
		pushStyle();
		fill(80);
		textFont(font);
		textAlign(lalign, ralign);
		text(text, x, y);
		popStyle();
	}
}
