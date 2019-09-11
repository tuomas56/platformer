pad(Bounce, BounceConsts, BounceState) {
    params {
        boost = 5.0;
        delta = 0.2;
    }

    state {
        bounce_time = 1.0;
    }

    draw {
        if state.bounce_time >= 1.0 {
            window.stroke(1.0, 1.0, 1.0, 1.0);
        } else {
            let a = 1.0 - state.bounce_time * state.bounce_time * (10.0 - 10.0 * state.bounce_time).exp() / 150.0;
            window.stroke(a, a, 1.0, 1.0);
        }
        window.no_fill();
        window.stroke_weight(8.0);
        window.line(px, py, px + pw, py);
    }

    update {
        state.bounce_time += dt;
    }

    collision {
        if (px <= x) && 
            (x <= px + pw) && 
            (py - 4.0 <= y + r) && 
            (y + r <= py + 4.0) {
            if (jump_time < params.delta) && (jump_time >= 0.0)  {
                state.bounce_time = 0.0;
                Some(Collision {
                    restitution: 1.0,
                    position: (x, py - 4.0 - r),
                    normal: (0.0, -1.0),
                    tangent: (1.0, 0.0),
                    can_jump: false,
                    hard_surface: true
                })
            } else {
                Some(Collision {
                    restitution: 1.0,
                    position: (x, py - 4.0 - r),
                    normal: (0.0, -1.0),
                    tangent: (1.0, 0.0),
                    can_jump: false,
                    hard_surface: true
                })
            }
        } else {
            None
        }
    }
}

pad(Float, FloatConsts, FloatState) {
    params {
        height = 200.0;
        speed = 100.0;
    }

    state {}

    draw {
        window.stroke_weight(4.0); 
        for i in 0..(params.height as usize) {
            let a = 0.5 * (1.00 - (i as f32 / params.height).powf(0.5));
            window.stroke(a, a, a, a);
            window.line(px + 8.0, py - 8.0 - (i as f32), px + pw - 8.0, py - 8.0 - (i as f32));
        }

        window.fill(1.0, 1.0, 1.0, 1.0);
        window.stroke(1.0, 1.0, 1.0, 1.0);
        
        window.quad(px, py,
                    px + 8.0, py - 8.0,
                    px + pw - 8.0, py - 8.0,
                    px + pw, py);
    }

    update {
        particles.spawn(
            1,
            (px + 8.0, px + pw - 8.0),
            (py - 8.0, py - 8.0),
            (0.0, 3.141592/2.0),
            0.0,
            -1.0,
            params.speed / 2.0,
            -100.0,
            (1.0, 1.0, 1.0),
            3.0,
            ((params.speed * params.speed / 4.0 + 200.0 * params.height).sqrt() - (params.speed / 2.0))/100.0,
            1.0
        );
    }

    collision {
        if (px <= x) && 
            (x <= px + pw) && 
            (y + r <= py) && 
            (y + r >= py - params.height) {
            Some(Collision {
                restitution: 0.0,
                position: (x, y - params.speed * dt),
                normal: (0.0, -1.0),
                tangent: (1.0, 0.0),
                can_jump: true,
                hard_surface: false,
            })
        } else {
            None
        }
    }
}

pad(Spikes, SpikesConst, SpikesState) {
    params {
        width = 15.0;
        height = 10.0;
        facing = 1.0;
    }

    state {}

    draw {
        window.stroke(1.0, 1.0, 1.0, 1.0);
        window.fill(0.5, 0.5, 0.5, 1.0);
        window.stroke_weight(4.0);
        window.line(px, py, px + pw, py);
        let nspikes = (pw/params.width) as usize;
        match nspikes {
            0 | 1 => window.triangle(px, py, px + pw/2.0, py - params.facing * params.height, px + pw, py),
            _ => {
                let leftover = pw - params.width * (nspikes as f32);
                window.triangle(px, py, px + params.width/2.0 + leftover/2.0, py - params.facing * params.height, px + params.width + leftover/2.0, py);
                for n in 1..(nspikes - 1) {
                    window.triangle(
                        px + (n as f32)*params.width + leftover/2.0, py, 
                        px + (n as f32)*params.width + leftover/2.0 + params.width/2.0, py - params.facing * params.height,
                        px + ((n + 1) as f32)*params.width + leftover/2.0, py
                    );
                }
                window.triangle(
                    px + ((nspikes - 1) as f32) * params.width + leftover/2.0, py,
                    px + ((nspikes - 1) as f32) * params.width + leftover/2.0 + params.width/2.0, py - params.facing * params.height,
                    px + pw, py
                );
            }
        }
    }

    update {}
    
    collision {
        if (px <= x) && 
            (x <= px + pw) && 
            if params.facing > 0.0 {
                y + r <= py
            } else {
                y - r >= py
            } && 
            if params.facing > 0.0 {
                y + r >= py - params.facing * params.height
            } else {
                y - r <= py - params.facing * params.height
            } {
            Some(Collision {
                restitution: 0.0,
                position: (x, py - params.facing * params.height - r.copysign(params.facing)),
                normal: (0.0, -1.0),
                tangent: (1.0, 0.0),
                can_jump: true,
                hard_surface: false
            })
        } else {
            None
        }
    }
}