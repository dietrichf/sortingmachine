class AnimatedRenderer implements IRenderer {
	
	private SortingMachine m;

	AnimatedRenderer(SortingMachine m) {
		this.m = m;
	}
	
	public void setup() {
		m.setup();
	}

	public void tick() {
	}

	public void draw() {
	}
}
