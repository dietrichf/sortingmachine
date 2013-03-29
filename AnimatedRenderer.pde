class AnimatedRenderer implements Drawable {
	
	private SortingMachine m;

	private int pc = -1;

	AnimatedRenderer(SortingMachine m) {
		this.m = m;
		new ScheduledThreadPoolExecutor(1).scheduleAtFixedRate(
			new Runnable() {
				public void run() {
					nextInstruction();
				}
			}, 1, 1, TimeUnit.SECONDS);
	}
	
	public void setup() {
		System.out.println("configuring standard view");
		m.setup();
	}

	public void tick() {
	}

	private void nextInstruction() {
		println("next instruction");
	}

	public void draw() {
	}
}
