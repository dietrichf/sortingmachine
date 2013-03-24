class Renderer implements IRenderer {
	
	private SortingMachine m;

	Renderer(SortingMachine m) {
		this.m = m;
	}

	public void setup() {
		m.setup();
	}

	public void tick() { }

	public void draw() {

	}
}
