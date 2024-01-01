\c db_acdemic
CREATE TABLE course(id UUID UNIQUE PRIMARY KEY DEFAULT gen_random_uuid(), course_name VARCHAR(10), info jsonb);
CREATE TABLE curriculum(id UUID UNIQUE PRIMARY KEY DEFAULT gen_random_uuid(), major VARCHAR(10), links jsonb);

INSERT INTO course(course_name, info) VALUES ('MATH19A',
'{
"prereq_courses":"[]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CS,CE,EE]",
"title": "Calculus for Science, Engineering, and Mathematics/Calculus I",
"ge":"[MF]",
"description": "The limit of a function, calculating limits, continuity, tangents, velocities, and other instantaneous rates of change. Derivatives, the chain rule, implicit differentiation, higher derivatives. Exponential functions, inverse functions, and their derivatives. The mean value theorem, monotonic functions, concavity, and points of inflection. Applied maximum and minimum problems. Students cannot receive credit for both this course and MATH 11A, or AM 11A, or AM 15A, or ECON 11A."
}');

INSERT INTO course(course_name, info) VALUES ('MATH20A',
'{
"prereq_courses":"[]", 
"major_req": "[CS,CE]",
"major_quali": "[CS,CE,EE]",
"title": "Honors Calculus",
"ge":"[MF]",
"description": "Methods of proof, number systems, binomial and geometric sums. Sequences, limits, continuity, and the definite integral. The derivatives of the elementary functions, the fundamental theorem of calculus, and the main theorems of differential calculus."
}');

INSERT INTO course(course_name, info) VALUES ('MATH19B',
'{
"prereq_courses":"[MATH19A]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CS,CE,EE]",
"title": "Calculus II",
"ge":"[MF]",
"description": "The definite integral and the fundamental theorem of calculus. Areas, volumes. Integration by parts, trigonometric substitution, and partial fractions methods. Improper integrals. Sequences, series, absolute convergence and convergence tests. Power series, Taylor and Maclaurin series. Students cannot receive credit for both this course and MATH 11B, or AM 11B, or AM 15B, or ECON 11B."
}');

INSERT INTO course(course_name, info) VALUES ('MATH20B',
'{
"prereq_courses":"[MATH20A]", 
"major_req": "[CS]",
"major_quali": "[CS,CE,EE]",
"title": "Honors Calculus",
"ge":"[MF]",
"description": "Orbital mechanics, techniques of integration, and separable differential equations. Taylor expansions and error estimates, the Gaussian integral, Gamma function and Stirling''s formula. Series and power series, numerous applications to physics."
}');

INSERT INTO course(course_name, info) VALUES ('MATH21',
'{
"prereq_courses":"[{MATH19A,MATH20A}]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CE,EE]",
"title": "Linear Algebra",
"ge":"[MF]",
"description": "Systems of linear equations matrices, determinants. Introduces abstract vector spaces, linear transformation, inner products, the geometry of Euclidean space, and eigenvalues. Students cannot receive credit for this course and AM 10."
}');

INSERT INTO course(course_name, info) VALUES ('MATH23A',
'{
"prereq_courses":"[{MATH19B,MATH20B}]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CE,EE]",
"title": "Vector Calculus I",
"ge":"[MF]",
"description": "Vectors in n-dimensional Euclidean space. The inner and cross products. The derivative of functions from n-dimensional to m-dimensional Euclidean space is studied as a linear transformation having matrix representation. Paths in 3-dimensions, arc length, vector differential calculus, Taylor''s theorem in several variables, extrema of real-valued functions, constrained extrema and Lagrange multipliers, the implicit function theorem, some applications. Students cannot receive credit for this course and MATH 22 or AM 30."
}');

INSERT INTO course(course_name, info) VALUES ('MATH23B',
'{
"prereq_courses":"[MATH23A]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Vector Calculus II",
"ge":"[MF]",
"description": "Double integral, changing the order of integration. Triple integrals, maps of the plane, change of variables theorem, improper double integrals. Path integrals, line integrals, parametrized surfaces, area of a surface, surface integrals. Green''s theorem, Stokes'' theorem, conservative fields, Gauss'' theorem. Applications to physics and differential equations, differential forms."
}');

INSERT INTO course(course_name, info) VALUES ('MATH24',
'{
"prereq_courses":"[{MATH22,MATH23A}]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Ordinary Differential Equations",
"ge":"[]",
"description": "First and second order ordinary differential equations, with emphasis on the linear case. Methods of integrating factors, undetermined coefficients, variation of parameters, power series, numerical computation. Students cannot receive credit for this course and AM 20."
}');


INSERT INTO course(course_name, info) VALUES ('AM10',
'{
"prereq_courses":"[]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CE,EE]",
"title": "Engr Math Methods I",
"ge":"[MF]",
"description": "Applications-oriented course on complex numbers and linear algebra integrating Matlab as a computational support tool. Introduction to complex algebra. Vectors, bases and transformations, matrix algebra, solutions of linear systems, inverses and determinants, eigenvalues and eigenvectors, and geometric transformations. Students cannot receive credit for this course and for AM 10A or MATH 21. (Formerly AMS 10.)"
}');

INSERT INTO course(course_name, info) VALUES ('AM20',
'{
"prereq_courses":"[]", 
"major_req": "[CE,CE,EE]",
"major_quali": "[CE,EE]",
"title": "Engr Math Methods II",
"ge":"[MF]",
"description": "Applications-oriented class on ordinary differential equations (ODEs) and systems of ODEs using Matlab as a computational support tool. Covers linear ODEs and systems of linear ODEs; nonlinear ODEs using substitution and Laplace transforms; phase-plane analysis; introduction to numerical methods. Students cannot receive credit for this course and for AM 20A or MATH 24. (Formerly AMS 20.)"
}');

INSERT INTO course(course_name, info) VALUES ('AM30',
'{
"prereq_courses":"[AM10,{MATH19B,MATH20B}]", 
"major_req": "[CS,CE]",
"major_quali": "[CE,EE]",
"title": "Multivariate Calculus for Engineers",
"ge":"[]",
"description": "Advanced multivariate calculus for engineering majors. Coordinate systems, parametric curves, and surfaces; partial derivatives, gradient, Taylor expansion, stationary points, constrained optimization; integrals in multiple dimensions; integrals over curves and surfaces. Applications to engineering form an integral part of the course."
}');







INSERT INTO course(course_name, info) VALUES ('CSE12/L',
'{
"prereq_courses":"[{CSE20,CSE30}]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CS,CE,EE]",
"title": "Computer Systems & Assembly Language",
"ge":"[]",
"description": "Introduction to computer systems and assembly language and how computers compute in hardware and software. Topics include digital logic, number systems, data structures, compiling/assembly process, basics of the system software, and computer architecture. Course is 7 credits with integrated laboratories illustrating concepts covered in lecture. Note that CSE 12 assumes some programming experience. Students can show programming experience by taking one of the courses listed in the prerequisite list below or by taking the CSE python Test-out Exam: https://undergrad.soe.ucsc.edu/cse-20-testout-exam (Formerly CSE 12 and CSE 12L)"
}');


INSERT INTO course(course_name, info) VALUES ('CSE13S',
'{
"prereq_courses":"[CSE12/L]", 
"major_req": "[CS,CE]",
"major_quali": "[CS,CE,EE]",
"title": "Computer Systems and C Programming",
"ge":"[]",
"description": "C programming, command line, shell programming, editors, debuggers, source code control, and other tools. Basic computer systems, algorithm design and development, data types, program structures. Develops understanding of process model, compile-link-execute build cycle, language-machine interface, memory, and data representation. Students cannot receive credit for both CSE 13S and CSE 13E. Course is 7 units (5 + 2) with integrated laboratory."
}');


INSERT INTO course(course_name, info) VALUES ('CSE16',
'{
"prereq_courses":"[{MATH19A,MATH19B}]", 
"major_req": "[CS,CE]",
"major_quali": "[CS,CE,EE]",
"title": "Discrete Mathematics",
"ge":"[MF]",
"description": "Introduction to applications of discrete mathematical systems. Topics include sets, functions, relations, graphs, predicate calculus, mathematical proof methods (induction, contraposition, contradiction), counting methods (permutations, combinations), and recurrences. Examples are drawn from computer science and computer engineering. Knowledge of computer programming is useful before taking this course. Students who do not have prior programming experience are strongly recommended to take CSE 20 or CSE 30 before taking this course."
}');

INSERT INTO course(course_name, info) VALUES ('CSE20',
'{
"prereq_courses":"[]", 
"major_req": "[CS,CE]",
"major_quali": "[]",
"title": "Beginning Programming Python",
"ge":"[MF]",
"description": "Provides students with Python programming skills and the ability to design programs and read Python code. Topics include data types, control flow, methods and advanced functions, built-in data structures, and introduction to OOP. No prior programming experience is required. Students may not receive credit for CSE 20 after receiving credit for CSE 30. Students with prior programming experience (especially in Python) are encouraged to take CSE Testout Exam to be evaluated for their readiness to take CSE 30 directly: https://undergrad.soe.ucsc.edu/cse-20-testout-exam. (Formerly CMPS 5P, Introduction to Programming in Python.)"
}');


INSERT INTO course(course_name, info) VALUES ('CSE30',
'{
"prereq_courses":"[CSE20,MATH19A]", 
"major_req": "[CS,CE]",
"major_quali": "[CS,CE,EE]",
"title": "Programming Abstractions in Python",
"ge":"[]",
"description": "Introduction to software development in Python focusing on structuring software in terms of objects endowed with primitive operations. Introduces concepts and techniques via a sequence of concrete case studies. Coursework consists of programming assignments and a final examination."
}');


INSERT INTO course(course_name, info) VALUES ('CSE101',
'{
"prereq_courses":"[{CSE12,BME160},{CSE13E,ECE13,CSE13S},CSE16,CSE30,{MATH11B,MATH19B,MATH20B,AM11B}]", 
"major_req": "[CS,CE]",
"major_quali": "[]",
"title": "Introduction to Data Structures and Algorithms",
"ge":"[]",
"description": "Introduction to abstract data types and basics of algorithms. Linked lists, stacks, queues, hash tables, trees, heaps, and graphs will be covered. Students will also be taught how to derive big-Oh analysis of simple algorithms. All assignments will be in C/C++. (Formerly Computer Science 101 Algorithms and Abstract Data Types.)"
}');


INSERT INTO course(course_name, info) VALUES ('CSE107',
'{
"prereq_courses":"[CSE16,{AM30,MATH22,MATH23A}]", 
"major_req": "[CE]",
"major_quali": "[]",
"title": "Probability and Statistics for Engineers",
"ge":"[SR]",
"description": "Introduction to fundamental tools of stochastic analysis. Probability, conditional probability; Bayes Theorem; random variables and transforms; independence; Bernnoulli trials. Statistics, inference from limited data; outcomes of repeated experiments; applications to design; assessment of relative frequency and probability; law of large numbers; precision of measurements. Elements of stochastic processes, Poisson processes; Markov chains. Students cannot receive credit for this course and Applied Mathematics and Statistics 131. (Formerly Computer Engineering 107.)"
}');


INSERT INTO course(course_name, info) VALUES ('CSE100/L',
'{
"prereq_courses":"[CSE12]", 
"major_req": "[CE]",
"major_quali": "[]",
"title": "Logic Design",
"ge":"[]",
"description": "Boolean algebra, logic minimization, finite-state machine design, sequential circuits, common logic elements, programmable logic devices, and an introduction to system level design. The electrical behavior of circuits including three state outputs, propagation delay, logic levels, and fanout."
}');

INSERT INTO course(course_name, info) VALUES ('CSE185E',
'{
"prereq_courses":"[{CSE12,CSE15,CSE30,BME160}]", 
"major_req": "[CE]",
"major_quali": "[]",
"title": "Technical Writing for Computer Science and Engineering",
"ge":"[]",
"description": "Writing by engineers and computer scientists to technical audiences. Writing exercises include: cover letter and resume for job application, tutorial writing, grant proposal, document specification, literature review, and a final technical report. Two oral presentations are also required, an in-class presentation and a poster presentation. Students also receive instruction in the use of UC library and journal database resources, and in the writing of a statement of purpose for graduate school application. Also offered as CSE 185S. (Formerly Computer Engineering 185, Technical Writing for Computer Engineers.)"
}');


INSERT INTO course(course_name, info) VALUES ('CSE120',
'{
"prereq_courses":"[CSE12/L,{CSE13E,CSE13S,CSE11,CSE14/L}]", 
"major_req": "[CE]",
"major_quali": "[]",
"title": "Computer Architecture",
"ge":"[]",
"description": "Introduction to computer architecture including examples of current approaches and the effect of technology and software. Computer performance evaluation, basic combinatorial and sequential digital components, different instruction set architectures with a focus on the MIPS ISA and RISC paradigm. Evolution of CPU microarchitecture from single-cycle to multi-cycle pipelines, with overview of super-scalar, multiple-issue and VLIW. Memory system, cache, virtual memory and relationship between memory and performance. Evolution of PC system architecture. May include advanced topics, such as parallel processing, MIMD, and SIMD. (Formerly Computer Engineering 110.)"
}');


INSERT INTO course(course_name, info) VALUES ('CSE121',
'{
"prereq_courses":"[CSE12,CSE100/L,{CSE13E,CSE13S,ECE13,CSE15/L},ECE101/L,PHYS5C,PHYS5N]", 
"major_req": "[CE]",
"major_quali": "[]",
"title": "Embedded System Design",
"ge":"[]",
"description": "The design and use of microprocessor-based embedded systems. Covers microprocessor and microcontroller architecture, programming techniques, bus and memory organization, DMA, timing issues, interrupts, peripheral devices, serial and parallel communication, and interfacing to analog and digital systems. (Formerly Microprocessor System Design, and formerly offered as two courses, CMPE 121 and CMPE 121L.)"
}');






INSERT INTO course(course_name, info) VALUES ('PHYS5A/L',
'{
"prereq_courses":"[]", 
"major_req": "[CE,EE]",
"major_quali": "[CE,EE]",
"title": "Intro to Physics I Mechanics",
"ge":"[MF]",
"description": "Elementary mechanics. Vectors, Newton''s laws, inverse square force laws, work and energy, conservation of momentum and energy, and oscillations."
}');

INSERT INTO course(course_name, info) VALUES ('PHYS5B/M',
'{
"prereq_courses":"[PHY5A/L]", 
"major_req": "[CE,EE]",
"major_quali": "[]",
"title": "Intro to Physics II Waves & Optics",
"ge":"[SI]",
"description": "A continuation of PHYS 5A. Wave motion in matter, including sound waves. Geometrical optics, interference and polarization, statics and dynamics of fluids."
}');

INSERT INTO course(course_name, info) VALUES ('PHYS5C/N',
'{
"prereq_courses":"[{PHY5B/M,ECE9}]", 
"major_req": "[CE,EE]",
"major_quali": "[CE,EE]",
"title": "Intro to Physics III Electricity & Magnetism",
"ge":"[SI]",
"description": "Introduction to electricity and magnetism. Electromagnetic radiation, Maxwell''s equations."
}');

INSERT INTO course(course_name, info) VALUES ('PHYS5D',
'{
"prereq_courses":"[PHY5A/L,PHY5B,{MATH19B,MATH20B}]", 
"major_req": "[CE,EE]",
"major_quali": "[]",
"title": "Intro to Physics IV Heat & Thermodynamics",
"ge":"[]",
"description": "Introduces temperature, heat, thermal conductivity, diffusion, ideal gases, laws of thermodynamics, heat engines, and kinetic theory. Introduces the special theory of relativity and the equivalence principle. Includes the photoelectric effect, the Compton effect, matter waves, atomic spectra, and the Bohr model."
}');




INSERT INTO course(course_name, info) VALUES ('ECE9',
'{
"prereq_courses":"[PHY5A/L]", 
"major_req": "[CE]",
"major_quali": "[]",
"title": "Statics and Mechanics of Materials",
"ge":"[]",
"description": "Theory and application of statics and mechanics of materials for mechanical and biomechanical systems. Covers statics of particles; equilibrium of rigid bodies; free-body diagrams; analysis of structure; friction; concepts of stress and strain; axial loading; torsion and bending; and failure criteria. (Formerly Introduction to Statics, Dynamics, and Biomechanics.)"
}');

INSERT INTO course(course_name, info) VALUES ('ECE13',
'{
"prereq_courses":"[CSE12/L]", 
"major_req": "[CS,CE,EE]",
"major_quali": "[CS,CE,EE]",
"title": "Embedded Systems and C Programming",
"ge":"[]",
"description": "Computer Systems and C Programming is a class intended to bring you up to speed on programming small and large programs in C. Originally written in 1978, C remains the most  popular programming language, and the most used one in terms of numbers of computer programs  written in it. In this class, we are going to approach C from an embedded paradigm, and all of your programming  assignments are going to be on a 32-bit embedded micro, the Microchip PIC32. You will learn how to program in C, how to write modular code, and some of the tips and tricks  when dealing with an embedded micro. This is a programming class and you will be writing lots of code. Expect to spend at least 15-20 hours outside of class playing with the code to get things to work. (Formerly CSE 13E Embedded Systems and C Programming)"
}');

INSERT INTO course(course_name, info) VALUES ('ECE80T',
'{
"prereq_courses":"[]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Modern Electronic Technology and How It Works",
"ge":"[SI]",
"description": "Basic knowledge of electricity and how things work, how technology evolves, its impact on society and history, and basic technical literacy for the non-specialist. Broad overview of professional aspects of engineering and introduction and overview of basic systems and components. Topics include electrical power, radio, television, radar, computers, robots, telecommunications, and the Internet. (Formerly EE 80T.)"
}');

INSERT INTO course(course_name, info) VALUES ('ECE151',
'{
"prereq_courses":"[ECE103,ECE101/L,{CSE107,STAT131}]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Communications Systems",
"ge":"[]",
"description": "An introduction to communication systems. Analysis and design of communication systems based on radio, transmission lines, and fiber optics. Topics include fundamentals of analog and digital signal transmission in the context of baseband communications, including concepts such as modulation and demodulation techniques, multiplexing and multiple access, channel loss, distortion, bandwidth, signal-to-noise ratios and error control. Digital communication concepts include an introduction to sampling and quantization, transmission coding and error control. (Formerly EE 151.)"
}');

INSERT INTO course(course_name, info) VALUES ('ECE103/L',
'{
"prereq_courses":"[ECE101/L,{AM20,MATH24}]", 
"major_req": "[EE,CE]",
"major_quali": "[]",
"title": "Signals and Systems",
"ge":"[]",
"description": "Course covers the following topics: characterization and analysis of continuous-time signals and linear systems, time domain analysis using convolution, frequency domain analysis using the Fourier series and the Fourier transform, the Laplace transform, transfer functions and block diagrams, continuous-time filters, sampling of continuous time signals, examples of applications to communications and control systems. (Formerly EE 103.)"
}');

INSERT INTO course(course_name, info) VALUES ('ECE171/L',
'{
"prereq_courses":"[ECE101/L]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Analog Electronics",
"ge":"[]",
"description": "Introduction to (semiconductor) electronic devices. Conduction of electric currents in semiconductors, the semiconductor p-n junction, the transistor. Analysis and synthesis of linear and nonlinear electronic circuits containing diodes and transistors. Biasing, small signal models, frequency response, and feedback. Operational amplifiers and integrated circuits. (Formerly EE 171.)"
}');

INSERT INTO course(course_name, info) VALUES ('ECE101/L',
'{
"prereq_courses":"[{PHYS5C/N,PHYS6C/N},{MATH24,AM20}]", 
"major_req": "[EE,CE]",
"major_quali": "[]",
"title": "Introduction to Electronic Circuits",
"ge":"[]",
"description": "Introduction to the physical basis and mathematical models of electrical components and circuits. Topics include circuit theorems (Thevenin and Norton Equivalents, Superposition), constant and sinusoidal inputs, natural and forced response of linear circuits. Introduction to circuit/network design, maximum power transfer, analog filters, and circuit analysis using Matlab. Topics in elementary electronics including amplifiers and feedback. (Formerly EE 101.)"
}');


INSERT INTO course(course_name, info) VALUES ('ECE135',
'{
"prereq_courses":"[ECE101/L,MATH23B,{MATH24,AM20}]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Electromagnetic Fields and Waves",
"ge":"[]",
"description": "Vector analysis. Electrostatic fields. Magnetostatic fields. Time-varying fields and Maxwell''s equations. Plane waves. (Formerly EE 135.)"
}');


INSERT INTO course(course_name, info) VALUES ('ECE102/L',
'{
"prereq_courses":"[{[PHYS5A/L,PHYS5B/M,PHYS5C/N],PHYS6A/L,PHYS6B/M,PHYS6C/N]}]", 
"major_req": "[EE]",
"major_quali": "[]",
"title": "Properties of Materials",
"ge":"[]",
"description": "The fundamental electrical, optical, and magnetic properties of materials, with emphasis on metals and semiconductors: chemical bonds, crystal structures, elementary quantum mechanics, energy bands. Electrical and thermal conduction. Optical and magnetic properties. (Formerly EE 145.)"
}');




INSERT INTO curriculum(major, links) VALUES ('CE',
'{
"url":"https://undergrad.soe.ucsc.edu/sites/default/files/file-content-type/2021-10/CMPE_21-22.pdf" 
}');

INSERT INTO curriculum(major, links) VALUES ('CS',
'{
"url":"https://undergrad.soe.ucsc.edu/sites/default/files/file-content-type/2021-10/CS_BA_21-22.pdf"
}');

INSERT INTO curriculum(major, links) VALUES ('EE',
'{
"url":"https://undergrad.soe.ucsc.edu/sites/default/files/file-content-type/2021-10/EE_21-22.pdf"
}');