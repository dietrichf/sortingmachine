class SortingMachine {
	
	private SortingMachineConfig config;

	SortingMachine(SortingMachineConfig config) {
		this.config = config;
	}

	SortingMachine(String file) {
		try {
			ObjectMapper om = new ObjectMapper();
			Map<String, Object> config = om.readValue(new File("/Users/d/git/sortvis/config.json"), Map.class);
			System.out.println("config ->\n" + config);
			this.config = new SortingMachineConfig(config);
		}
		catch(Exception e) {
			e.printStackTrace(System.err);
			throw new RuntimeException(e);
		}
	}

	public void setup() {
		size(this.config.getWindow().getWidth(), this.config.getWindow().getHeight());
		smooth();
	}

	public IRenderer getRenderer() {
		if(this.config.isAnimated()) {
			return new AnimatedRenderer(this);
		}
		return new Renderer(this);
	}
}

