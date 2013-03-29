class LabelDrawable implements Drawable {
	private final int lalign, ralign;
	private float x, y;
	private PFont font;
	private String text;
	LabelDrawable(String text, float x, float y, int lalign, int ralign, PFont font) {
		this.text = text;
		this.x = x;
		this.y = y;
		this.lalign = lalign;
		this.ralign = ralign;
		this.font = font;
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
