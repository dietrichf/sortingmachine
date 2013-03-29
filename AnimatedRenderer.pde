class AnimatedRenderer implements Drawable {
	
	private SortingMachine m;

	private int pc = -1;

	private List<Drawable> instructionDrawables;

	float playerX = 0f, playerY = 0f;
	Integrator playerOffsetX = new Integrator(0);

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
		playerX = m.getWindow().getLeftMargin();
		playerY = m.getWindow().getTopMargin();
		float cursorX = 0f, cursorY = 0f;
		for(SortJob job : m.getSortJobs()) {
			DataSet data = job.getData();
			instructionDrawables = Lists.newArrayListWithCapacity(job.getInstructions().size());
			for(Instruction instruction : job.getInstructions()) {
				InstructionDrawable d =
					new InstructionDrawable(
						instruction,
						cursorX, cursorY,
						m.getNoteHeight(), m.getStepWidth(),
						data.getValues()
					);
				instructionDrawables.add(d);
				cursorX += m.getStepWidth();
			}
			break;
		}
	}

	public void tick() {
		playerOffsetX.tick();
		for(Drawable d : instructionDrawables) {
			d.tick();
		}
	}

	public void draw() {
		background(255,255,255);
		pushMatrix();
		playerOffsetX.target((float)pc * m.getStepWidth());
		translate(width/2 - playerOffsetX.value - playerX, playerY);
		for(int i = 0; i < instructionDrawables.size(); i++) {
			Drawable d = instructionDrawables.get(i);
			d.draw();
		}
		popMatrix();
	}

	private void nextInstruction() {
		pc++;
	}
}
