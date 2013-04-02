class AnimatedRenderer implements Drawable {
	
	private SortingMachine m;

	private int pc = -1;

	private List<InstructionDrawable> instructionDrawables;
	private ArrayDrawable arrayDrawable;
	private List<ArrayDrawable> snapshots;
	private List<Instruction> program;

	float playerX = 0f, playerY = 0f;
	Integrator playerOffsetX = new Integrator(0);

	private AtomicBoolean sendInstruction = new AtomicBoolean(false);

	AnimatedRenderer(SortingMachine m) {
		this.m = m;
		new ScheduledThreadPoolExecutor(1).scheduleAtFixedRate(
			new Runnable() {
				public void run() {
					sendInstruction.set(true);
				}
			}, 500L, 500L, TimeUnit.MILLISECONDS);
	}
	
	public void setup() {
		System.out.println("configuring standard view");
		m.setup();
		playerX = m.getWindow().getLeftMargin();
		playerY = m.getWindow().getTopMargin();
		float cursorX = 0f, cursorY = 0f;
		SortJob job = m.getSortJobs().get(0);
		DataSet data = job.getData();
		program = job.getInstructions();
		instructionDrawables = Lists.newArrayListWithCapacity(program.size());
		for(Instruction instruction : program) {
			InstructionDrawable d =
				new InstructionDrawable(
					instruction,
					cursorX, cursorY,
					m.getNoteHeight(), m.getStepWidth(),
					data.getValues()
				);
			d.setup();
			instructionDrawables.add(d);
			cursorX += m.getStepWidth();
		}
		arrayDrawable =
			new ArrayDrawable(
				data.getValues(), // values
				m.getWindow().getLeftMargin(), // x
				m.getNoteHeight()*data.getValues().length + m.getWindow().getTopMargin(), // y
				width - m.getWindow().getLeftMargin() - m.getWindow().getRightMargin(),
				200,
				50, 20, 50, 20
			);
		arrayDrawable.setup();
		takeSnapshot();

		int[] a = copy(data.getValues());
		println("before -->\n" + join(a, ", ") + "\n");
		for(Instruction i : program) {
			i.exec(a);
		}
		println("after -->\n" + join(a, ", ") + "\n");
	}

	private void takeSnapshot() {
		if(snapshots == null) {
			snapshots = Lists.newArrayList();
		}
		ArrayDrawable s = arrayDrawable.clone();
		s.setup();
		s.setColor(0, 0, 0, 0);
		snapshots.add(s);
	}

	public void tick() {
		if(sendInstruction.get()) {
			nextInstruction();
			sendInstruction.set(false);
		}
		playerOffsetX.tick();
		for(int i = 0; i < instructionDrawables.size(); i++) {
			InstructionDrawable d = instructionDrawables.get(i);
			d.tick();
			// set 'executing' flag if necessary
			d.setExecuting(i == pc);
		}
		arrayDrawable.tick();
		layoutSnapshots();
		for(Drawable s : snapshots) {
			s.tick();
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
		arrayDrawable.draw();
		for(ArrayDrawable s : snapshots) {
			s.draw();
		}
		//saveFrame("/tmp/sorting-machine/seq-####.tif");
	}

	private void nextInstruction() {
		pc++;
		if(pc > program.size() - 1) {
			pc = program.size() - 1;
			//noLoop();
			return;
		}

		Instruction i = program.get(pc);
		arrayDrawable.execute(i);

		// record the state of the array after the swap
		if(i.swap()) {
			takeSnapshot();
		}
	}

	private void layoutSnapshots() {
		float visibleWidth = width - m.getWindow().getLeftMargin() - m.getWindow().getRightMargin();
		float sx = m.getWindow().getLeftMargin();
		float sy = arrayDrawable.y.target + arrayDrawable.dheight.target;
		float swidth = visibleWidth/12f;
		float sheight = swidth * 9f / 16f;
		for(ArrayDrawable d : snapshots) {
			d.reposition(sx, sy, swidth, sheight, 10f, 10f, 10f, 10f);
			d.targetColor(0, 0, 0, 100);
			sx += swidth;
			if((sx+swidth)> (width-m.getWindow().getRightMargin())) {
				sx = m.getWindow().getLeftMargin();
				sy += sheight;
			}
		}
	}
}
